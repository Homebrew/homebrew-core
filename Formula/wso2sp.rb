class Wso2sp < Formula
  desc "WSO2 Stream Processor"
  homepage "https://wso2.com/analytics-and-stream-processing/"
  url "https://dl.bintray.com/wso2/binary/wso2sp-4.3.0.zip"
  sha256 "5bf84f3c4ca54f8b7e5c493042bbe8d2e44bb45db6de509f4e4b8b2a3d4cd0aa"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    %w[
      dashboard
      editor
      worker
      manager
    ].each do |profile|
      bin.install "bin/wso2sp-#{version}-#{profile}" => "wso2sp-#{profile}"
    end

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/wso2/dashboard/logs/*"]

    pid = fork do
      system testpath/"bin/wso2sp-dashboard"
    end
    Process.detach(pid)
    sleep 10

    assert_predicate testpath/"wso2/dashboard/logs/carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
