class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.23.0.tar.gz"
  sha256 "00646b692762ffd340560e8f16486dbda840e1546749ee5a7f58feeb77e7b516"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_sonoma:   "01d161fa4c64a9b227218a7001c53daf856770ceeba139eef4eca96d5f7fbb3a"
    sha256 cellar: :any_skip_relocation, arm64_ventura:  "cd5b28cf93d48eb69c4083b32011476d34aac9a69f85a1fed888efc65f309544"
    sha256 cellar: :any_skip_relocation, arm64_monterey: "b9964a02089ae6dc420bd0d52e53d795c1eb91921698d52aef1eccf27b93a09f"
    sha256 cellar: :any_skip_relocation, sonoma:         "0a369934112432c852d250e433370c2b40e4a2dfa8dbb7b5296a4b21eadd3f7f"
    sha256 cellar: :any_skip_relocation, ventura:        "3c5823f4e8d58ed2521465bcf0feaa11882aca9fd69517172b68a67210da0e88"
    sha256 cellar: :any_skip_relocation, monterey:       "681fac041860e1d345090ee7be11a2ec2aaed52dba4fbd4cc4f1cee43f0aba86"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "cce87484cb55d141718486811fe0d0e35aaf7c47ae4c9ad6070b3563da66534a"
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
