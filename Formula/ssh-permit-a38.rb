class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/v0.2.0.tar.gz"
  sha256 "cb8d94954c0e68eb86e3009d6f067b92464f9c095b6a7754459cfce329576bd9"
  revision 1

  bottle do
    cellar :any
    rebuild 1
    sha256 "3eefd64fbbe3e4d500a69352091da85ca685a435094facc30e6942d9d5e89a1d" => :catalina
    sha256 "683ebbe9a6a845802f825f1775e6d861387be41fd520b648275f97a580e92398" => :mojave
    sha256 "7d82d59932bb6d721a31726efc231d043d54d180995d0119d8f8bf9fc37f3e9b" => :high_sierra
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", "--locked", "--root", prefix, "--path", "."
  end

  test do
    system bin/"ssh-permit-a38 host 1.exmaple.com add"

    assert File.readlines("ssh-permit.json").grep(/1.exmaple.com/).size == 1,
      "Test host not found in ssh-permit.json"
  end
end
