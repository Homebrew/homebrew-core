class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/v0.2.0.tar.gz"
  sha256 "cb8d94954c0e68eb86e3009d6f067b92464f9c095b6a7754459cfce329576bd9"
  revision 1

  bottle do
    sha256 "79aa6e33c91a8cb2dd5c2f30277bc17b26b877010cf07a49ca212e2882085c2b" => :mojave
    sha256 "d4a7dc99358b86444ccde5f25ca78c1750eb28ae9e602b2021884660c88efe04" => :high_sierra
    sha256 "9cd48f3b1c0bd568dd5a303bd4b69f42e84ef29e883bc5f9738cfd84030c066d" => :sierra
    sha256 "548a878a784eda04a5c1601dcf17d7fb908b65eebd9fe44b39b3d7bc609d1575" => :el_capitan
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
