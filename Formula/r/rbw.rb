class Rbw < Formula
  desc "Unofficial Bitwarden CLI client"
  homepage "https://github.com/doy/rbw"
  url "https://github.com/doy/rbw/archive/refs/tags/1.15.0.tar.gz"
  sha256 "660cfa4c727711665bef060046c28dd3924ca1e490fdc058d90d35372b2d2cf6"
  license "MIT"
  head "https://github.com/doy/rbw.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "9a88f350032d2483d232eabbc3e46c8fbc60e085a5ed12247f89c035a2b72baf"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "9cbc933c4e5e51465c29b6212d49a4d03247937fc4c90aed8d412233b362129f"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "29d9fc3d4465dd237935d27c1c41e626ccb6034e49a4df606428f688f6116588"
    sha256 cellar: :any_skip_relocation, sonoma:        "4f584f865654725385535191270b91c45edf332168d1c92ca8be3675b46f8816"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "51122b2935b55e07ecfcacac075b53b22f9959476d4b236f925608d83c9aa1c3"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "8a6d35509dc98788cf077746b87916d4e0640cb902a517bffc66196c80622989"
  end

  depends_on "rust" => :build
  depends_on "pinentry"

  def install
    system "cargo", "install", *std_cargo_args

    generate_completions_from_executable(bin/"rbw", "gen-completions")
  end

  test do
    expected = "ERROR: Before using rbw"
    output = shell_output("#{bin}/rbw ls 2>&1 > /dev/null", 1).each_line.first.strip
    assert_match expected, output
  end
end
