class Wso2am < Formula
  desc "WSO2 API Manager"
  homepage "https://wso2.com/api-management/"
  url "https://dl.bintray.com/wso2/binary/wso2am-2.6.0.zip"
  sha256 "a493009e2e0c7034d31369ad9fe1c34a76680d32ac77920dceab6d496626230d"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    bin.install "bin/wso2am-#{version}" => "wso2am"

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/repository/logs/*"]

    pid = fork do
      system testpath/"bin/wso2am"
    end
    Process.detach(pid)
    sleep 15

    assert_predicate testpath/"repository/logs/wso2carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
