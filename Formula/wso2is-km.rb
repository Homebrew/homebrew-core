class Wso2isKm < Formula
  desc "WSO2 Identity Server as a Key Manager"
  homepage "https://wso2.com/api-management/"
  url "https://dl.bintray.com/wso2/binary/wso2is-km-5.7.0.zip"
  sha256 "52f70ff6b97bdf56cea2b1e4bd591d84ffeb12b80ff0b4236e7d3776cf9fda13"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    bin.install "bin/wso2is-km-#{version}" => "wso2is-km"

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/repository/logs/*"]

    pid = fork do
      system testpath/"bin/wso2is-km"
    end
    Process.detach(pid)
    sleep 15

    assert_predicate testpath/"repository/logs/wso2carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
