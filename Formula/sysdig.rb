class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://www.sysdig.org/"
  url "https://github.com/draios/sysdig/archive/0.24.2.tar.gz"
  sha256 "cd925afd2fb0a26728611666e017d480afd49158c2d70714c7461a97c8820807"

  bottle do
    sha256 "a0bb49d52b0c5d642a00a1ed79c1ab1c168ab4599a659e56b6cb757a25f90eb7" => :mojave
    sha256 "36c522e0747bc61571e6fa80f51e391bcf13b5f3be2327907ee2d1b993082819" => :high_sierra
    sha256 "38dddc103333a960c118f606efee5bbd686f307a1f327ab7fc3071be6c6a7c9b" => :sierra
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
