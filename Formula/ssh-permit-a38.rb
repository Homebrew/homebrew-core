class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/v0.2.0.tar.gz"
  sha256 "cb8d94954c0e68eb86e3009d6f067b92464f9c095b6a7754459cfce329576bd9"
  revision 1

  bottle do
    cellar :any
    sha256 "4de4d364ee99fdaa45d77d37c26dab88ccd70233172687722e269268c8a411da" => :catalina
    sha256 "ae34a5a46ef16528db572b93ed733a17f001bdbe23bcd07b6410c958e04d5186" => :mojave
    sha256 "4de9caa719a5c0a569fbb09fee2df9a0db5df4eaad8046cb05ad8258a641f419" => :high_sierra
    sha256 "31bfaaee0093524bbc33a809cac2ec4f6ff66d73aea13a9e4a3ae3a8c71b0fcd" => :sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--root", prefix, "--path", "."
  end

  test do
    system bin/"ssh-permit-a38 host 1.exmaple.com add"

    assert(File.readlines("ssh-permit.json").grep(/1.exmaple.com/).size == 1, "Test host not found in ssh-permit.json")
  end
end
