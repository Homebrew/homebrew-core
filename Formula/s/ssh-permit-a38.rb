class SshPermitA38 < Formula
  desc "Central management and deployment for SSH keys"
  homepage "https://github.com/ierror/ssh-permit-a38"
  url "https://github.com/ierror/ssh-permit-a38/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "cb8d94954c0e68eb86e3009d6f067b92464f9c095b6a7754459cfce329576bd9"
  license "MIT"
  revision 1

  bottle do
    rebuild 2
    sha256 cellar: :any,                 arm64_sonoma:   "0c9ed9e40aee04a34d31a3ee2f84978b2298302533b45eacf0dbe306f21457d4"
    sha256 cellar: :any,                 arm64_ventura:  "96e3d6e8f730a4e618df2dcdbb9e34d0d984279493ff7f0fd9584d45e0eb5a77"
    sha256 cellar: :any,                 arm64_monterey: "7e4ba428801c4fc9ec23517e01dad136586e61052bd4d9205bfb75a652ac2136"
    sha256 cellar: :any,                 arm64_big_sur:  "ddc1b8ed3b76e9acbce18af5b81a4cf16942821a3e328843ab99c954b80c69d3"
    sha256 cellar: :any,                 sonoma:         "c57921695d62d0afea5a9879326892f495d5969dd7e3820fa3450473fdcf593a"
    sha256 cellar: :any,                 ventura:        "3010fccaf8e110218ce7db40be84d70613fc52dbfa51559aba086ac3503501f4"
    sha256 cellar: :any,                 monterey:       "f45f37f3fdbd00b71083b3039cc95e38c77e3f49ea7d8c6d69713bc6833738fc"
    sha256 cellar: :any,                 big_sur:        "be4350f56a90a669e3406b1fc47569970d7282b2d17fa3b72b0655a7a05afd82"
    sha256 cellar: :any,                 catalina:       "7c6141113cbb8821cfc7c5b88c5b29a5290585f923898eb3ac04fcbc3b060ed4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "ef88b670035ed8bc6bcba5290a1bf297237a7abcaeb243c1d686f0e45683cbd7"
  end

  # Match deprecation date of `openssl@1.1`. openssl-sys==0.9.27 doesn't support `openssl@3`
  # Last release on 2018-08-18
  disable! date: "2024-08-01", because: :unmaintained

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
    system bin/"ssh-permit-a38 host 1.example.com add"

    assert File.readlines("ssh-permit.json").grep(/1.example.com/).size == 1,
      "Test host not found in ssh-permit.json"
  end
end
