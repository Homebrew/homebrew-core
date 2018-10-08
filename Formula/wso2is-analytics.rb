class Wso2isAnalytics < Formula
  desc "WSO2 Identity Server Analytics"
  homepage "https://wso2.com/identity-and-access-management/"
  url "https://dl.bintray.com/wso2/binary/wso2is-analytics-5.7.0.zip"
  sha256 "74dff66b9d5474b95758ce799d3894eb32923269b2031da2342e581aff9620f5"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    %w[
      dashboard
      worker
      manager
    ].each do |profile|
      bin.install "bin/wso2is-analytics-#{version}-#{profile}" => "wso2is-analytics-#{profile}"
    end

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/wso2/dashboard/logs/*"]

    pid = fork do
      system testpath/"bin/wso2is-analytics-dashboard"
    end
    Process.detach(pid)
    sleep 10

    assert_predicate testpath/"wso2/dashboard/logs/carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
