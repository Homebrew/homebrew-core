class Ruri < Formula
  desc "Program that calculates the CRC-32 and checks it against the filename"
  homepage "https://gitlab.com/Timmy1e/ruri/"
  url "https://gitlab.com/Timmy1e/ruri/-/archive/v2.0.0/ruri-v2.0.0.tar.gz"
  sha256 "65638f066d5f1f319b4a3ba82ed214a31dbdd8a5ab34d3bbff9b85df38c67b2e"
  license "AGPL-3.0-or-later"

  depends_on "rust" => :build

  def install
    system("cargo", "install", *std_cargo_args, "--bin", "ruri")
    prefix.install_metafiles
  end

  test do
    File.write("file_one[367B63B8].txt", "This is a homebrew test file\n")
    assert_match(
      "367B63B8  file_one[367B63B8].txt\n",
      shell_output("#{bin}/ruri -q file_one[367B63B8].txt"),
    )

    File.write("file_two[FEB9A153].txt", "This is another test file\n")
    assert_match(
      /✓ 1  ⁉ 0  × 0  ‼ 0  ⏲ \d+ms \d+us \d+ns \n/,
      shell_output("#{bin}/ruri file_two[FEB9A153].txt"),
    )
  end
end
