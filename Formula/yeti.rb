class Yeti < Formula
  desc "ML-style functional programming language that runs on the JVM"
  homepage "https://mth.github.io/yeti/"
  url "https://github.com/mth/yeti/archive/v0.9.9.1.tar.gz"
  sha256 "c552018993570724313fc0624d225e266cd95e993d121850b34aa706f04e3dfe"
  head "https://github.com/mth/yeti.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "5bb8d8a2c4ba29c5e4cab58c9c0ba9ad53ee19d48f1845885b49d8cf3f2e83f0" => :catalina
    sha256 "5945caa7c11f1424c971fbd1df5c0e904526dc69b35897bab7c34fcd1a2895e9" => :mojave
    sha256 "b9d0083c8220cb02f5b994998149904613bceb589b7fb265bb9964e5af7dbb18" => :high_sierra
    sha256 "5298c83ec842d28b26bf4d1cec151e2ae674509c27778de0aeacaf365711e7b9" => :sierra
    sha256 "268781d28a766896e5ef40dc5c364b8a40617e6c28a3c96b693eba473c56e660" => :el_capitan
    sha256 "a1ef95834d3631f7d04e18fd90786b0c8b0f4e492abe6f665a64d0d31ee768c5" => :yosemite
    sha256 "9dd1a7662b45c454c47075ee029c554bf2655423376bd373cde6e15e716e7677" => :mavericks
  end

  depends_on "ant" => :build
  depends_on :java => "1.8"

  def install
    system "ant", "jar"
    libexec.install "yeti.jar"
    bin.write_jar_script libexec/"yeti.jar", "yeti", "-server"
  end

  test do
    assert_equal "3\n", shell_output("#{bin}/yeti -e 'do x: x+1 done 2'")
  end
end
