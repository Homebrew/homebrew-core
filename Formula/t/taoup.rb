class Taoup < Formula
  desc "Tao of Unix Programming with Ruby-powered ANSI-colored fortunes"
  homepage "https://github.com/globalcitizen/taoup"
  url "https://github.com/globalcitizen/taoup/archive/refs/tags/v1.1.24.tar.gz"
  sha256 "9e9569343d57420e39526f65c1f9f4372b1019e9379517ff5224b7723a0c4538"
  license "GPL-3.0-or-later"

  # Upstream has used a mixture of tag formatting, resulting in incorrect matches
  livecheck do
    url :stable
    strategy :github_latest
  end

  depends_on "ruby"

  resource "ansi" do
    url "https://rubygems.org/downloads/ansi-1.6.0.gem"
    sha256 "ac9ea0c0ea8d32fb4e271348e609963ac78882f34b73836c2a02b3622e666658"
  end

  def install
    ENV["GEM_HOME"] = libexec

    resources.each do |r|
      system "gem", "install", r.cached_download, "--ignore-dependencies",
             "--no-document", "--install-dir", libexec
    end

    libexec.install "taoup", "taoup-fortune"

    %w[taoup taoup-fortune].each do |cmd|
      (bin/cmd).write_env_script libexec/cmd,
                                 GEM_HOME: libexec,
                                 PATH:     "#{formula_opt_bin("ruby")}:$PATH"
    end
  end

  test do
    output = shell_output("#{bin}/taoup --machine")
    assert_match "Rule of Zero, One or Infinity", output

    fortune = shell_output(bin/"taoup-fortune")
    refute_empty fortune.strip
  end
end
