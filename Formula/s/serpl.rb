class Serpl < Formula
  desc "Simple terminal UI for search and replace"
  homepage "https://github.com/yassinebridi/serpl"
  url "https://github.com/yassinebridi/serpl/archive/refs/tags/0.3.5.tar.gz"
  sha256 "ac53081d4610da6597b90ee785c4f6dbf553e7653bcebc0689a26931e1a4dd76"
  license "MIT"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "b88504be53fd6c6d0f4aedfafa8b85242e6f35383517fe9c5886ab52aa55ea25"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "ad317368e476c6488b780e9910742ab649c6563e3fe2c8296801603c3915f9ba"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "aa13125f545f6dccc7766f4dd49a5e4632b8dc9bab43fef97e414134c5d709d3"
    sha256 cellar: :any_skip_relocation, sonoma:        "89f5f9abd344d6f2401d42f476de2fe68c615aa2af5d707fb94d74c4303f3a6d"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "b69c0b32ca5b58b5c8a3181b0ccc601bc9f8a7361f35bd26c99e5979f5ebc9fb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a119bda728e51a5938e737cd0a5609212daf6701aeab6216ead96b1550dbc2b7"
  end

  depends_on "rust" => :build
  depends_on "ripgrep"

  def install
    system "cargo", "install", *std_cargo_args
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/serpl --version")

    assert_match "a value is required for '--project-root <PATH>' but none was supplied",
      shell_output("#{bin}/serpl --project-root 2>&1", 2)
  end
end
