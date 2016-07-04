class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.9.0.tar.gz"
  sha256 "72a809b32153713e6d8697e86ee821eb969fa0ec486fa7432471374feb0f1da5"

  bottle do
    sha256 "dbe1d7ff71b897c90c0f03ce5eaf58b99ec1bda0e13b0fac8291673931dd4888" => :el_capitan
    sha256 "d4e74babf2536adc5a3ae0f945d1bd8c2c5973ffc21eafda520093ed37db42bd" => :yosemite
    sha256 "bcf38bd0513fefff5ed41f6ebf908d348050c7c9157c58e047656fe6f8ce29b2" => :mavericks
  end

  depends_on "cmake" => :build
  depends_on "luajit"

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    ENV.libcxx if MacOS.version < :mavericks

    mkdir "build" do
      args = %W[
        -DSYSDIG_VERSION=#{version}
        -DUSE_BUNDLED_LUAJIT=OFF
        -DUSE_BUNDLED_ZLIB=OFF
      ] + std_cmake_args

      system "cmake", "..", *args
      system "make", "install"
    end

    (share/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    # tests if it can load chisels
    `#{bin}/sysdig -cl`
    assert_equal 0, $?.exitstatus

    # tests if it can read a sample capture file
    # uses a custom output format because evt.time (in default format) is not UTC
    expected_output = "1 open fd=5(<f>/tmp/sysdig/sample.scap) name=sample.scap(/tmp/sysdig/sample.scap) flags=262(O_TRUNC|O_CREAT|O_WRONLY) mode=0"

    assert_equal expected_output, `#{bin}/sysdig -r #{share}/demos/sample.scap -p "%evt.num %evt.type %evt.args" "evt.type=open and evt.arg.name contains /tmp/sysdig/sample.scap"`.strip
    assert_equal 0, $?.exitstatus
  end
end
