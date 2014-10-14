require 'open3'

describe "bin/call_rota" do
  let(:people_fixture_path) { "spec/fixtures/people.csv" }
  let(:production_access_fixture_path) { "spec/fixtures/production_access.csv" }
  # let(:output_file_path) { Tempfile.new.path }
  let(:output_file_path) { "/tmp/output.csv" }

  it "fails if no people file is provided" do
    parameters = "--production_access #{production_access_fixture_path} #{output_file_path}"
    stderr, exit_status = run_script(parameters)

    expect(exit_status).to be 1
    expect(stderr).to match(/Please specify a --people argument/)
  end

  it "fails if no production_access file is provided" do
    parameters = "--people #{people_fixture_path} #{output_file_path}"
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
