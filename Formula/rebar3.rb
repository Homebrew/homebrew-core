class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.13.1.tar.gz"
  sha256 "706cc0770062bde2674abc01964c68553398fe4d8023605b305cfe326b92520f"

  bottle do
    cellar :any_skip_relocation
    sha256 "aeb7b608161e8fb26272567152ef69517dea2ad86a0cee79acdea9cd80138c8a" => :catalina
    sha256 "7cac813a4bc54a194f39f397a7c902c6cae975209c00a1e85e50822dafc75a0f" => :mojave
    sha256 "b413261ceea64de954ad755d0b600f3ae75fc064ee45aa6c5e38af6fd35b55b0" => :high_sierra
  end

  depends_on "erlang"

  def install
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "priv/shell-completion/bash/rebar3"
    zsh_completion.install "priv/shell-completion/zsh/_rebar3"
    fish_completion.install "priv/shell-completion/fish/rebar3.fish"
  end

  test do
    system bin/"rebar3", "--version"
  end
end
