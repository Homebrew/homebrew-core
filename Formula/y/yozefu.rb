class Yozefu < Formula
  desc "TUI for exploring data in a Kafka cluster"
  homepage "https://github.com/MAIF/yozefu"
  url "https://github.com/MAIF/yozefu/archive/refs/tags/v0.0.16.tar.gz"
  sha256 "217b53f15cabeba0bfe36e4acbe026cae18c8c091408e654bd7c96f6f32b1aa3"
  license "Apache-2.0"
  head "https://github.com/MAIF/yozefu.git", branch: "main"

  bottle do
    sha256 cellar: :any,                 arm64_tahoe:   "44c4dddd4a562cf39601a40552610fe43883ea2b138b710bcff1b720b95a9ab4"
    sha256 cellar: :any,                 arm64_sequoia: "c9bd56eae053736e86a429371188aa0abff4aa4f46e55e842f3433b87b552c45"
    sha256 cellar: :any,                 arm64_sonoma:  "6f097a68cdd627be0c329a3b6ceeb10fadff1d1bb0f941dbccf3650890f672b2"
    sha256 cellar: :any,                 sonoma:        "db7b818616c463ff3ea10f745daa6236dd7e2db26109eb1bd40cc06001299ada"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "771398f014e5a96b9380fc77bc33ce3fc6f02632efd91938b939515b8633c947"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "fb61486a1ec9576d101d0823d048a6d77d31d1f4590050414e998d538abc0444"
  end

  depends_on "cmake" => :build
  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  uses_from_macos "llvm" => :build # for libclang

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args(path: "crates/bin")
  end

  test do
    require "utils/linkage"

    assert_match version.to_s, shell_output("#{bin}/yozf --version")

    output = shell_output("#{bin}/yozf config get a 2>&1", 1)
    assert_match "Error: There is no 'a' property in the config file", output

    [
      Formula["openssl@3"].opt_lib/shared_library("libssl"),
      Formula["openssl@3"].opt_lib/shared_library("libcrypto"),
    ].each do |library|
      assert Utils.binary_linked_to_library?(bin/"yozf", library),
             "No linkage with #{library.basename}! Cargo is likely using a vendored version."
    end
  end
end
