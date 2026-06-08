class Tuckr < Formula
  desc "Super powered replacement for GNU Stow"
  homepage "https://raphgl.github.io/Tuckr/"
  url "https://github.com/RaphGL/Tuckr/archive/refs/tags/0.13.1.tar.gz"
  sha256 "4b3bdc51e5de5961d89021f28e5aa1ae976fe37330ffafaa5042ed7d6ee2c7c7"
  license "GPL-3.0-or-later"
  head "https://github.com/RaphGL/Tuckr.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "53bb3a9c01895a2030156e5914c2be6385b42f3f4b735ebe527c7becae05f926"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "39e80458c6a75f14f12ebb0401ab9a4b294ff6ef38cf576769b54980aae358d1"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "f7904f08a47d3cdbd8c39eae475ef03c5253d600e618b7e54d6fe2e91511a348"
    sha256 cellar: :any_skip_relocation, sonoma:        "3b7ff703677b33d74065b649f34d3625161ea5beac468f4c6bae621be07870e3"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b46206b7d2fbab691d89eea6ffd6f06b69ef6fdc2881c77a515b27da7140c4c1"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "912dd0019e140f2d24322b5d01e9146f07f66571db709b02cb5c43a30d54d779"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    output = shell_output("#{bin}/tuckr status 2>&1", 2)
    assert_match "Couldn't find dotfiles directory", output
    assert_match "run `tuckr init`.", output
    assert_match version.to_s, shell_output("#{bin}/tuckr --version")
  end
end
