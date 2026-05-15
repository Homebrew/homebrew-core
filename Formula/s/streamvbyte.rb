class Streamvbyte < Formula
  desc "Fast integer compression in C"
  homepage "https://github.com/fast-pack/streamvbyte"
  url "https://github.com/fast-pack/streamvbyte/archive/refs/tags/v3.0.0.tar.gz"
  sha256 "6f1fcd6b3e2e0d301d8c8691be12290f7c10611f43075c8e6c53dc5c2131fe89"
  license "Apache-2.0"
  head "https://github.com/fast-pack/streamvbyte.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b9b38be68f098c19220568c2efca7d24eadc1031874cc0b3fb7ef21c4f321732"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "d9bd3c8fd90242a4afa1353cb261f823472455a8d531fe50d92675d9c61ef419"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dbcc8adcefbbf9ee6c4f87995871b974e103a7f5041efa91621cb1643fdd3219"
    sha256 cellar: :any_skip_relocation, sonoma:        "5078507dec276064feb608d062f9644d39a5a2fda48b2d4288b5ad40e5898abe"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76f3550eff1da0051efa3f6154f744504d1958d913635b244cbe029430dddc43"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8485dc5e02365f948be578f4639016e77eb30d78f1ebf2b298c001e3e6fede46"
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
