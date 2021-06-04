class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.27.1.tar.gz"
  sha256 "b9d05854493d245a7a7e75f77fc654508f720aab5e5e8a3a932bd8eb54e49bda"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:  "9caf5620dbeadf8e87bf19a598baa7bae5f6c0d1643666182fe91972806e6d84"
    sha256 catalina: "7a21384d18bf9848f7fc91b6deb2099b01f44952e9ce88cbee3f53c0b8f1f33e"
    sha256 mojave:   "e29dcafe2de6f4fecc5e32ceb9d81c6bbab6b252dae5056ee8e617ac5204911a"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
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
                            "-DCREATE_TEST_TARGETS=OFF",
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
