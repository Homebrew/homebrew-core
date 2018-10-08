class Wso2ei < Formula
  desc "WSO2 Enterprise Integrator"
  homepage "https://wso2.com/integration/"
  url "https://dl.bintray.com/wso2/binary/wso2ei-6.4.0.zip"
  sha256 "36ab3982cc517674ab1673c1947093bf8022e1f4fb971a2fe6fa1b3085a13917"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    %w[
      integrator
      business-process
      broker
      analytics-dashboard
      analytics-worker
      micro-integrator
      msf4j
    ].each do |profile|
      bin.install "bin/wso2ei-#{version}-#{profile}" => "wso2ei-#{profile}"
    end

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/repository/logs/*"]

    pid = fork do
      system testpath/"bin/wso2ei-integrator"
    end
    Process.detach(pid)
    sleep 15

    assert_predicate testpath/"repository/logs/wso2carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
