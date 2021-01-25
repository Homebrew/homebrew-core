class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.27.1.tar.gz"
  sha256 "b9d05854493d245a7a7e75f77fc654508f720aab5e5e8a3a932bd8eb54e49bda"
  license "Apache-2.0"

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 "9a5db7570b079c111525694e6aef53bab77f7633fd30550c174fdd0d8b241ce1" => :big_sur
    sha256 "a3343b2e42ca8df82c537170b0338d965bc0c92619f760d86f30d6f898610e5f" => :catalina
    sha256 "843c5ff29eb7787e1bfc5393f0562e6f97c121504f652f5fd806943dc971b97e" => :mojave
    sha256 "f314c5445253bd052d4a7f50b3e879a81514f14c4d44b3887da26e69fbdce17f" => :high_sierra
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
