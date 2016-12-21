class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.13.0.tar.gz"
  sha256 "2a5e744cef11348aa36d88bff9974557727e3b632a41e4b3b5e1903d0e911d3e"

  bottle do
    sha256 "522a784dcdb5d2e9ff0405c0c15438870add62e60dc4e8a596185c9363f9a9a7" => :sierra
    sha256 "203a4f65b8fe39cc23ba0fca399b2e6aea253d2fef76fd6bf42bbd18b4dbb3a9" => :el_capitan
    sha256 "90b04d78383f1a7ee08d230a607405e5bce96330e155b67de41d5af29d7d1b56" => :yosemite
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
