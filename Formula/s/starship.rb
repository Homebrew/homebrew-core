class Starship < Formula
  desc "Cross-shell prompt for astronauts"
  homepage "https://starship.rs/"
  url "https://github.com/starship/starship/archive/refs/tags/v1.23.0.tar.gz"
  sha256 "be3ba025a64bd808899dce256e1511145b55cc5eefc5fca82bf5537cd8e09c72"
  license "ISC"
  head "https://github.com/starship/starship.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "e0f085c4ec44508be2fda1fd8d89ef9d7cc2207026e7db1da5a9d922d7046498"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c8a074bbded5edb346475e4bf3c6faecc13b15486cd75ffd7dc102c65369adad"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "75d22389bb70b46e23553898ce23d583a4cfb5a3b6de712952da815f980c5511"
    sha256 cellar: :any_skip_relocation, sonoma:        "f0df06b16b67cb040c0f139dddd7df3df7985ccd8be93ac31a17e9dbb8a354b2"
    sha256 cellar: :any_skip_relocation, ventura:       "18594cec9c012f3bc91272d79a5d0edf6143a64122f8c1f99b6b253c12b8483b"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "2eaa4272f26775db67f3ed107e97a4392d96adcfcbdf5141e5ba696987e23051"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "80cfca3624de24391aa69ce0c357a669e793384410cbc3b9facd982c0f1b437d"
  end

  depends_on "cmake" => :build
  depends_on "rust" => :build

  uses_from_macos "zlib"

  on_linux do
    depends_on "pkgconf" => :build
    depends_on "dbus"
  end

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"starship", "completions")
  end

  test do
    ENV["STARSHIP_CONFIG"] = ""
    assert_equal "[1;32m❯[0m ", shell_output("#{bin}/starship module character")
  end
end
