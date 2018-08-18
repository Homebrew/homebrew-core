class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/v0.2.0.tar.gz"
  sha256 "cb8d94954c0e68eb86e3009d6f067b92464f9c095b6a7754459cfce329576bd9"

  bottle do
    sha256 "d774fd98f0b2aefcaba0db410063585db805e4ab9023b998f35fd8718fd5adf6" => :high_sierra
    sha256 "beb046cddc23b07fc4515801f88518a51fb64d3e8700216dc43726d651cafb2c" => :sierra
    sha256 "9e0ed513b2f1881c5e68c753be1991b17405aea15ac7933945ac43559f97f9ad" => :el_capitan
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl"

  def install
    ENV["OPENSSL_INCLUDE_DIR"] = Formula["openssl"].opt_include
    ENV["DEP_OPENSSL_INCLUDE"] = Formula["openssl"].opt_include
    ENV["OPENSSL_LIB_DIR"] = Formula["openssl"].opt_lib
    system "cargo", "install", "--root", prefix
  end

  test do
    system bin/"ssh-permit-a38 host 1.exmaple.com add"

    assert(File.readlines("ssh-permit.json").grep(/1.exmaple.com/).size == 1, "Test host not found in ssh-permit.json")
  end
end
