class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.26.4.tar.gz"
  sha256 "7c15ee25abf6cca850eaf6f4e42e25a1d9ad2b775ae794028f94afbd1ce9d271"

  bottle do
    sha256 "b9a7d0cbbbe218af6cd21aceda2770aa329cbf1634738f63258be86760340eb6" => :mojave
    sha256 "403ae83a910f96c3ac445ab65c1214840ff1df3831f565adf1c253592c6877d7" => :high_sierra
    sha256 "8a74e6797c271830849807a677523f600c9f69eb97c9faba91ed1bdfb7b436cf" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "tbb"

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
      system "make"
      system "make", "install"
    end

    (pkgshare/"demos").install resource("sample_file").files("sample.scap")
  end

  test do
    output = shell_output("#{bin}/sysdig -r #{pkgshare}/demos/sample.scap")
    assert_match "/tmp/sysdig/sample", output
  end
end
