class RattlerIndex < Formula
  desc "Index conda channels using rattler"
  homepage "https://github.com/conda/rattler"
  url "https://github.com/conda/rattler/archive/refs/tags/rattler_index-v0.25.3.tar.gz"
  sha256 "c0c105a2ab7ddee8f34b590d18d52e37649cbc900febef54a81ba3958e88d0a6"
  license "BSD-3-Clause"
  head "https://github.com/conda/rattler.git", branch: "main"

  livecheck do
    url :stable
    regex(/^rattler_index-v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7bf53473493703fc8bfbc0b864bc14aa3a6f603184844e0271b7202db0bf2258"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "970879bdca22d22b868ad7579b4cc02b8cc497fa972be205f4279f9fb918599e"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "20afb2a0410d661876ca110a9955ff6fc39ce8adf96d2681d2dc490e9f20bb38"
    sha256 cellar: :any_skip_relocation, sonoma:        "b379445dc8b15206699d5cef7a31393582c3d082f8a9b4a0c9c7b79033d6503c"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "76e4d2532e9eaf622ca39f54fd02bb0c23dbdd292e85aad9d6c85bb615100671"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "738974ec46b2cb079cd26596515bcaf31961cf5f96175af74b01a719dc475a46"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build

  on_linux do
    depends_on "openssl@3"
  end

  def install
    system "cargo", "install", "--features", "native-tls,rattler_config", "--no-default-features",
        *std_cargo_args(path: "crates/rattler_index")
  end

  test do
    assert_equal "rattler-index #{version}", shell_output("#{bin}/rattler-index --version").strip

    system bin/"rattler-index", "fs", "."
    assert_path_exists testpath/"noarch/repodata.json"
  end
end
