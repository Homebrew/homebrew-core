class Wso2is < Formula
  desc "WSO2 Identity Server"
  homepage "https://wso2.com/api-management/"
  url "https://dl.bintray.com/wso2/binary/wso2is-5.7.0.zip"
  sha256 "f02c992bc9083ff72810b64a3e5e7915a3280cc0df165a5ae2abf9f7093ce10b"

  bottle :unneeded

  depends_on :java => "1.8"

  def install
    bin.install "bin/wso2is-#{version}" => "wso2is"

    libexec.install Dir["*"]
    bin.env_script_all_files(libexec/"bin", Language::Java.java_home_env("1.8"))
  end

  test do
    ENV["CARBON_HOME"] = testpath
    cp_r Dir["#{libexec}/*"], testpath
    rm Dir["#{testpath}/repository/logs/*"]

    pid = fork do
      system testpath/"bin/wso2is"
    end
    Process.detach(pid)
    sleep 15

    assert_predicate testpath/"repository/logs/wso2carbon.log", :exist?

    Process.kill("SIGINT", pid)
  end
end
