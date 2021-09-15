class Sysdig < Formula
  desc "System-level exploration and troubleshooting tool"
  homepage "https://sysdig.com/"
  url "https://github.com/draios/sysdig/archive/0.27.1.tar.gz"
  sha256 "b9d05854493d245a7a7e75f77fc654508f720aab5e5e8a3a932bd8eb54e49bda"
  license "Apache-2.0"
  revision 2

  livecheck do
    url :stable
    strategy :github_latest
  end

  bottle do
    sha256 big_sur:      "5d26c152781c472694c45d59a73e9650859be3f329023e3d55ec28aedcd3257f"
    sha256 catalina:     "a587a80a9969ef9a280834f08c21b90753cf33d716a0df608a5d8f97c5e81043"
    sha256 mojave:       "6bb2d53d4fa74604759a32bfd9d68acf1fca9c54b28476467a026e3c1d7275a3"
    sha256 x86_64_linux: "dbbfa26450d7f99efece407d00ed265842f37a6ee588c75caeebdbd58a2439e4"
  end

  depends_on "cmake" => :build
  depends_on "c-ares"
  depends_on "jsoncpp"
  depends_on "luajit"
  depends_on "tbb"

  uses_from_macos "curl"

  on_linux do
    depends_on "elfutils"
    depends_on "grpc"
    depends_on "jq"
    depends_on "libb64"
    depends_on "protobuf"
  end

  # More info on https://gist.github.com/juniorz/9986999
  resource "sample_file" do
    url "https://gist.githubusercontent.com/juniorz/9986999/raw/a3556d7e93fa890a157a33f4233efaf8f5e01a6f/sample.scap"
    sha256 "efe287e651a3deea5e87418d39e0fe1e9dc55c6886af4e952468cd64182ee7ef"
  end

  def install
    args = std_cmake_args + %W[
      -DSYSDIG_VERSION=#{version}
      -DUSE_BUNDLED_DEPS=OFF
      -DCREATE_TEST_TARGETS=OFF
    ]
    args << "-DBUILD_DRIVER=OFF" if OS.linux?

    mkdir "build" do
      system "cmake", "..", *args
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
