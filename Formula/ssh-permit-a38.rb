class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/v0.2.0.tar.gz"
  sha256 "cb8d94954c0e68eb86e3009d6f067b92464f9c095b6a7754459cfce329576bd9"
  license "MIT"
  revision 1

  bottle do
    rebuild 1
    sha256 cellar: :any,                 arm64_monterey: "ef2eb0850cf670b3b15074cf03e601be8e4d9dacbad032044b4352b5a5827c5d"
    sha256 cellar: :any,                 arm64_big_sur:  "68df2c83ee0648226ee00df59ae6837dc97cce0c105487f5307be28615b2c3f4"
    sha256 cellar: :any,                 monterey:       "e81cc7c78138751c3563ad1efac04789fddb2c938888edcc66c5714a43447782"
    sha256 cellar: :any,                 big_sur:        "ed50251803a0e7fc976589be8b84f2cb7a149e871e1241b3f9819d5219413e99"
    sha256 cellar: :any,                 catalina:       "3eefd64fbbe3e4d500a69352091da85ca685a435094facc30e6942d9d5e89a1d"
    sha256 cellar: :any,                 mojave:         "683ebbe9a6a845802f825f1775e6d861387be41fd520b648275f97a580e92398"
    sha256 cellar: :any,                 high_sierra:    "7d82d59932bb6d721a31726efc231d043d54d180995d0119d8f8bf9fc37f3e9b"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "f45aa317ce341e24ffc8ba21c39bc3f46935a2d7ef4e74d299dba3ed6a58f11b"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build
  depends_on "openssl@1.1"

  uses_from_macos "zlib"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    # https://crates.io/crates/openssl#manual-configuration
    ENV["OPENSSL_DIR"] = Formula["openssl@1.1"].opt_prefix

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"ssh-permit-a38 host 1.exmaple.com add"

    assert File.readlines("ssh-permit.json").grep(/1.exmaple.com/).size == 1,
      "Test host not found in ssh-permit.json"
  end
end
