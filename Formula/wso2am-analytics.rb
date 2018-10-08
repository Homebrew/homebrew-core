class Wso2amAnalytics < Formula
  desc "WSO2 API Manager Analytics"
  homepage "https://wso2.com/api-management/"
  url "https://dl.bintray.com/wso2/binary/wso2am-analytics-2.6.0.zip"
  sha256 "c92795e7e8257b1767c1252cb307fef8add2f495abc4b15cb69e54248d76a813"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    %w[
      dashboard
      worker
      manager
    ].each do |profile|
      bin.install "bin/wso2am-analytics-#{version}-#{profile}" => "wso2am-analytics-#{profile}"
    end

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/repository/logs/*"]

    pid = fork do
      system testpath/"bin/wso2am-analytics-dashboard"
    end
    Process.detach(pid)
    sleep 10

    assert_predicate testpath/"wso2/dashboard/logs/carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
