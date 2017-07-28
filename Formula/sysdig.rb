class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.17.0.tar.gz"
  sha256 "f009acc32f2b15fcb0d2267bde6f6de9b3445179003c979ba61a8836abdb78f9"

  bottle do
    sha256 "b13af9d6e45d2e98a618260158b1c26659dd423f41a4251799967843dc08759a" => :sierra
    sha256 "117bacb02f18ce4ebf4c3d0da0a1b48e81e8cca720903593598330addce2d26a" => :el_capitan
    sha256 "5dd18c1ce877c2a5a640a1befde9f2e5f6123248cd1ac5933c8089b89c808ee5" => :yosemite
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
