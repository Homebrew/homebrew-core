class Scooter < Formula
  desc "Interactive find and replace in the terminal"
  homepage "https://github.com/thomasschafer/scooter"
  url "https://github.com/thomasschafer/scooter/archive/refs/tags/v0.2.0.tar.gz"
  sha256 "2ceb6851de8e98df3ed3defb42bbdb871253bf98813e33df8c7727a8aeaaf4a1"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "42c24265d21662bf88e062d40d1b4fb2827c27cc57862a285ce014389c9d00b6"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "8ec477aa12f681baf8a44c67ced470c843524e805058173369cb1de1768ad1c7"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c11689d5b5304333cc4614408630dd69962b7873cc38c217c73f6aea4657cba6"
    sha256 cellar: :any_skip_relocation, sonoma:        "f4f644e8f1749eee6281bfc1fd74bd88b37c7fc2a6b0bd2bb0606f0f0a2d2d82"
    sha256 cellar: :any_skip_relocation, ventura:       "e74c429f0d6e9f8cdc0514a8c8f22b997f3c04b337bbbc2813768f056bacf439"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f97b76a4de7d194a577a7b37857113e38c9296333a9f4d077ad705e4101d3e36"
  end

  depends_on "rust" => :build

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    # scooter is a TUI application
    assert_match "Interactive find and replace TUI.", shell_output("#{bin}/scooter -h")
  end
end
