class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://fast-pack.github.io/streamvbyte/"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v3.2.0.tar.gz"
  sha256 "7a9b180ef7385c023260786f3521f761066dd0eb1ea1a21890e9dce00f9c85cf"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "a36b4ece621e040bce3841ba2de2ee0477692daea0c711a2f212305002402bea"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "23b1620773a57e0cc53a232d18af0370ead421e8c98afe47720c4abc53e82c2d"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ee9820d762603a5e1f05a6999b1a507ebe1c8b5cfd14edf55f9ffbb0641773f8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "af27b5306bc0f0e863f2bc93c4b96b73ad003b8d54be34f5a046687cbe2caab7"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "8612ea063d21a7d4f7d1680485ad349ab56598ccd3fd6773aceadd6dd2e33073"
  end

  depends_on "cmake" => :build

  def install
    system "cmake", "-S", ".", "-B", "build", "-DCMAKE_POLICY_VERSION_MINIMUM=3.5", *std_cmake_args
    system "cmake", "--build", "build"
    system "cmake", "--install", "build"

    pkgshare.install "examples/example.c"
  end

  test do
    system ENV.cc, pkgshare/"example.c", "-I#{include}", "-L#{lib}", "-lstreamvbyte", "-o", "test"
    system testpath/"test"
  end
end
