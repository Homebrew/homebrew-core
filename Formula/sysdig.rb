class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.22.1.tar.gz"
  sha256 "b0ca30473c813c8086187e171f1b8faee6e72689fc02cb1e54ff9f8563bfbe89"

  bottle do
    sha256 "3aea3be0ce9deaba75b258ce3ba7ca0c8d3c5fbdf9e72d076a64474dcd9a85d9" => :high_sierra
    sha256 "23a81a39fa3b637fd3f9c83c75da5b4323104248c8fbde98c42eaf4108a66ecf" => :sierra
    sha256 "2992763fc294816e942cc2b006bcbf41026d6ca9d7f49606efb3ac90ed59f6b7" => :el_capitan
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
