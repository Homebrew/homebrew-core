class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.22.1.tar.gz"
  sha256 "b0ca30473c813c8086187e171f1b8faee6e72689fc02cb1e54ff9f8563bfbe89"

  bottle do
    sha256 "8d7881cf882bdf9caab088fcb75ce6acc20b36bd3291580c185a3562ca739568" => :high_sierra
    sha256 "b85d07f24981336dd1b11fd70bad32f4725c7e451c46e5eccfb16ee92d960a64" => :sierra
    sha256 "66f6dab8016693d093b5c2aba6e148563b9edd8d1bc0f444c294c781ff665671" => :el_capitan
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
    ENV.libcxx if MacOS.version < :mavericks

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
