class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.24.2.tar.gz"
  sha256 "cd925afd2fb0a26728611666e017d480afd49158c2d70714c7461a97c8820807"
  revision 2

  bottle do
    sha256 "9c4ac6dedb0a77e4f5c56c3b06c7b4cfff6db36f1e12760ede76e19426ae9e3a" => :mojave
    sha256 "433e2a2116865ac8e74897366402a9198e443ba166ccc7b15098834ed0fde8e0" => :high_sierra
    sha256 "cc86be285b1efcd1b53101f1d4b6f25d32ac036cd74e492813615dbb257bd4ff" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    mkdir "build" do
      system "cmake", "..", "-DSYSDIG_VERSION=#{version}",
                            "-DUSE_BUNDLED_DEPS=OFF",
                            *std_cmake_args
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
