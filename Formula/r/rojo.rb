class Rojo < Formula
  desc "Professional grade Roblox development tools"
  homepage "https://rojo.space/"
  # pull from git tag to get submodules
  url "https://github.com/rojo-rbx/rojo.git",
      tag:      "v7.6.1",
      revision: "825726c8835d26e37290cb7343e7765741aefefd"
  license "MPL-2.0"
  head "https://github.com/rojo-rbx/rojo.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "7342fb03360adf9da87f85e2f7e0a4d9165ed15fba501a5d570e417ea8131929"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bf6599feb5a14753afc072b730d5f13f288b7e85820b172c8086aca04ec8e06a"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "b06bacf8121e829628f38ef50ebe51088cb8c84cadb6b2662dc57faeb8d77042"
    sha256 cellar: :any_skip_relocation, sonoma:        "1dd5086711d202388aefd2c5c0bfa918474440258ca4d5f7bca95ec74cb2c99d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b89b0bbd30ab66f4bf75373ca1fd2334a19805b89a027282014a46bb7e90cbe0"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "cff0fe4bb57f025548214ff6227c8973ac5308a2414fde120542a0bb5332e7b7"
  end

  depends_on "pkgconf" => :build
  depends_on "rust" => :build
  depends_on "openssl@3"

  def install
    # Ensure that the `openssl` crate picks up the intended library.
    ENV["OPENSSL_DIR"] = Formula["openssl@3"].opt_prefix
    ENV["OPENSSL_NO_VENDOR"] = "1"

    system "cargo", "install", *std_cargo_args
  end

  test do
    system bin/"rojo", "init"
    assert_path_exists testpath/"default.project.json"

    assert_match version.to_s, shell_output("#{bin}/rojo --version")
  end
end
