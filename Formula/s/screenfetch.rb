class Screenfetch < Formula
  desc "Generate ASCII art with terminal, shell, and OS info"
  homepage "https://github.com/KittyKatt/screenFetch"
  url "https://github.com/KittyKatt/screenFetch/archive/refs/tags/v3.9.9.tar.gz"
  sha256 "65ba578442a5b65c963417e18a78023a30c2c13a524e6e548809256798b9fb84"
  license "GPL-3.0-or-later"
  head "https://github.com/KittyKatt/screenFetch.git", branch: "master"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "c72a4b90d0fb8ffa29a46c886c26d93470d5a46a447edbe880e736c4223a4e14"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "c72a4b90d0fb8ffa29a46c886c26d93470d5a46a447edbe880e736c4223a4e14"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "c72a4b90d0fb8ffa29a46c886c26d93470d5a46a447edbe880e736c4223a4e14"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "c72a4b90d0fb8ffa29a46c886c26d93470d5a46a447edbe880e736c4223a4e14"
    sha256 cellar: :any_skip_relocation, sonoma:        "b68576c5aa125ad2165db21d10aab8d618bf1b39f984d7aba6f9b5ea49024e42"
    sha256 cellar: :any_skip_relocation, ventura:       "b68576c5aa125ad2165db21d10aab8d618bf1b39f984d7aba6f9b5ea49024e42"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "a427038281e7efce1130d08f039d557bf1338d3f12a4ab3d316454496bde26b4"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "a427038281e7efce1130d08f039d557bf1338d3f12a4ab3d316454496bde26b4"
  end

  # `screenfetch` contains references to `/usr/local` that
  # are erroneously relocated in non-default prefixes.
  pour_bottle? only_if: :default_prefix

  def install
    bin.install "screenfetch-dev" => "screenfetch"
    man1.install "screenfetch.1"
  end

  test do
    system bin/"screenfetch"
  end
end
