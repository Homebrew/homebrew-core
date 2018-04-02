class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/v0.1.0.tar.gz"
  sha256 "933ba4512def25216d7798a6cf3c455634be8193098e2a55a82cb189ad8554e3"

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
