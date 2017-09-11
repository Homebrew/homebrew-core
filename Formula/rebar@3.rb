class RebarAT3 < Formula
  desc "Erlang build tool"
  homepage "https://github.com/erlang/rebar3"
  url "https://github.com/erlang/rebar3/archive/3.4.4.tar.gz"
  sha256 "0f7c860489dc4e4fcdc706a04690f791755870ff0e0582525b8ee9a78e911443"
  head "https://github.com/rebar/rebar3.git"

  bottle do
    cellar :any_skip_relocation
    sha256 "f308031dda9b3e08f653bab39a5ba824a2e909e3193119a0b4303d7d45475210" => :sierra
    sha256 "8ee6d81532dba979cdbd433144ee8d70e97d7d99913a05dce13a937c856b50ff" => :el_capitan
    sha256 "1986a379754920128cd1de56037c41d428521a44184d5f7045c64de0279c2a43" => :yosemite
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
