class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "http://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.12.1.tar.gz"
  sha256 "7d4ab158ea8059b2340c4b4cc40c315d30b508cb7236d2f079d4458bc2959691"

  bottle do
    sha256 "b7024d0b7d50c930fd576cf29447a784f7feb6686f7c00d1c286f4ab71b5f6c0" => :sierra
    sha256 "d89ec98baa3804cd86ef292d89e7328426b6fdb9ff04a788419b10490595dd2c" => :el_capitan
    sha256 "53bf36cf4d3baa778bb97beafd169070834c48f426b1fded49e41c8268f53401" => :yosemite
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
