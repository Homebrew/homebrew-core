class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.24.2.tar.gz"
  sha256 "cd925afd2fb0a26728611666e017d480afd49158c2d70714c7461a97c8820807"

  bottle do
    sha256 "f3eebe7276e7a1b5a579f6a095bcdad61c5c6429ada950e5d9abbf2660c59232" => :mojave
    sha256 "dd3b00038c5d3d6efaf2c1bc0faa2595f47337d849f1728dd063aa24db96ce16" => :high_sierra
    sha256 "42a2aa84a58542e09f47734e12af3986b0c4be83b1d362c48322c585e4aab87d" => :sierra
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
