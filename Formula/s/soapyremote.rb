class Soapyremote < Formula
  desc "Use any Soapy SDR remotely"
  homepage "https://github.com/pothosware/SoapyRemote/wiki"
  url "https://github.com/pothosware/SoapyRemote/archive/refs/tags/soapy-remote-0.5.2.tar.gz"
  sha256 "66a372d85c984e7279b4fdc0a7f5b0d7ba340e390bc4b8bd626a6523cd3c3c76"
  license "BSL-1.0"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:    "b245e94aaf094ec9511e1f0f47fcd40499db9d62d28d710e6c26d6753536e852"
    sha256 cellar: :any,                 arm64_sequoia:  "45db2916465bc4c352d69c0089f03f2fc39f1fe7c0dd193f657dd21f44b5be43"
    sha256 cellar: :any,                 arm64_sonoma:   "ffe12b4564bf9090e8d20a8befd7f1ae66783c90395052fe016f44bd0ada6343"
    sha256 cellar: :any,                 arm64_ventura:  "2bfd849620a751a566c7eea4101c31ee70b685bd220275171f5d3fa5ab615fee"
    sha256 cellar: :any,                 arm64_monterey: "abbd8323df9212a717d9d6dbf19fdb24fd55665548bdb5bd27111c7dbd523e6f"
    sha256 cellar: :any,                 sonoma:         "2a9951c5c2f6b01200efc94ffd6f19dc8001b3051759c3a793a4e606c4f7c9d8"
    sha256 cellar: :any,                 ventura:        "812dc85d3f0eab0fbdd201c4f7520250ee8997827b0cfa721306b1170e31ff27"
    sha256 cellar: :any,                 monterey:       "668170d64a27d4de6aae24d8a9965b788e2b956eb8db5c3d3adf6807c31478ba"
    sha256 cellar: :any_skip_relocation, arm64_linux:    "83938e8783f67851865ee4aaad50da21c0e6d7b33ed3cd9db8da0b786185e5be"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "afb465a0deb07570685ee8ce05b960f6b4159310db9403f49ef4d37d0eae0f09"
  end

  depends_on "cmake" => :build
  depends_on "soapysdr"

  def install
    # Workaround to build with CMake 4
    args = %w[-DCMAKE_POLICY_VERSION_MINIMUM=3.5]
    system "cmake", "-S", ".", "-B", "build", *args, *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"
  end

  test do
    output = shell_output("#{Formula["soapysdr"].bin}/SoapySDRUtil --check=remote")
    assert_match "Checking driver 'remote'... PRESENT", output
  end
end
