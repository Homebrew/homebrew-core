class Save3dsFuse < Formula
  desc "Extract/Import/FUSE for 3DS save/extdata/database"
  homepage "https://github.com/wwylele/save3ds"
  url "https://github.com/wwylele/save3ds/archive/refs/tags/v1.4.0.tar.gz"
  sha256 "3bf47e34db1f3e5162df5b8e67a5673b473b37bf0eaa729be28e5e7a62212858"
  license "Apache-2.0"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "e7066052c1d3ab588faf21f2dea3dfb908f4837fa7f361ad0c5af12ea2566fe0"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "1a602758550d203e0a7583b046eedabcefe521271bc833bb7031145b914a40bf"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "0e3183ee54ff79857302e409ffb95af7bde9e10c34c600139c2238b4179653bc"
    sha256 cellar: :any_skip_relocation, sonoma:        "d5877b7d8b6bf492e485d88513f330e032f64904e5259e1c31918d708da9de22"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "e1a18296ce539d04b8806a1743abf9c31713246a76bd987cf51a8e9b9b2c197e"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "4e9272100fe4d01b7fd078b9aec2e8ccdec2fe009f6b9f8959fbe69570c38650"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", "--no-default-features", *std_cargo_args(path: "save3ds_fuse")
  end

  test do
    # `save3ds_fuse` requires a mount path to operate correctly
    assert_match "Please specify one mount path", shell_output(bin/"save3ds_fuse")

    (testpath/"testfile").write "test"
    output = shell_output("#{bin}/save3ds_fuse --bare testfile #{testpath}/tmp 2>&1", 1)
    assert_match "Out-of-bound access, caused by corrupted data", output
  end
end
