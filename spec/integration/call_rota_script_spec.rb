require 'open3'
require 'csv'
require 'tempfile'

describe "bin/call_rota" do
  let(:people_fixture_path) { "spec/fixtures/people.csv" }
  let(:production_access_fixture_path) { "spec/fixtures/production_access.csv" }
  let(:output_file) { Tempfile.new('output.csv') }
  let(:output_file_path) { output_file.path }
  let(:valid_parameters) {
    [
      "--people #{people_fixture_path}",
      "--production_access #{production_access_fixture_path}",
      "--output #{output_file_path}",
    ].join(" ")
  }

  it "fails if no people file is provided" do
    parameters = "--production_access #{production_access_fixture_path} --output #{output_file_path}"
    stderr, exit_status = run_script(parameters)

    expect(exit_status).to be 1
    expect(stderr).to match(/Please specify a --people argument/)
  end

  it "fails if no production_access file is provided" do
    parameters = "--people #{people_fixture_path} --output #{output_file_path}"
    stderr, exit_status = run_script(parameters)

    expect(exit_status).to be 1
    expect(stderr).to match(/Please specify a --production_access argument/)
  end

  it "fails if no output file is provided" do
    parameters = "--people #{people_fixture_path} --production_access #{production_access_fixture_path}"
    stderr, exit_status = run_script(parameters)

    expect(exit_status).to be 1
    expect(stderr).to match(/Please specify a --output argument/)
  end

  it "generates an output file" do
    _, exit_status = run_script(valid_parameters)

    expect(exit_status).to be 0
    expect(File.zero?(output_file_path)).not_to be(true)
  end

  it "has three valid entries" do
    run_script(valid_parameters)
    output = output_csv_data

    expect(output.size).to be(1)
    expect(output.first.keys).to eq([:webops, :dev, :supplemental_dev])
  end

  def output_csv_data
    raw_data = File.read(output_file_path)
    csv = CSV.new(
      raw_data,
      :headers           => true,
      :header_converters => :symbol,
    )

    csv.to_a.map { |row| row.to_hash }
  end

  def run_script(parameters)
    cmd = "bin/call_rota #{parameters}"
    stderr = nil
    stdout = nil
    exit_status = nil

    Open3.popen3(cmd) do |_, out, err, wait_thr|
      stdout = out.read
      stderr = err.read
      exit_status = wait_thr.value.exitstatus
    end

    [stderr, exit_status]
  end
end
