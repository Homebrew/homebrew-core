class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.24.0.tar.gz"
  sha256 "391b0eaa2825bb427fef1e55a0d166493059175f57a33b00346b84a20398216c"
  license "Apache-2.0"
  revision 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    rebuild 2
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "6c00aba8ef8aa1954959241927a697dbb389af2e53113013ec740950859134b7"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "081a82ce85c737630c4f454e32031c095b5f7fb8c9139705c26ea1463b56bab2"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "daaf2e1860ada7bcaff3c59dd161611f4af4298893ee19d6b543523eecc060fd"
    sha256 cellar: :any_skip_relocation, sonoma:        "c53cf3cf89d153a1c22c75077eb23e917806af58aac6ab58053537227a438970"
    sha256 cellar: :any_skip_relocation, ventura:       "96c91363e3a00fc8b4cf1187601941bda4dff426e3e79f06f924225ea6de1c2f"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "75743131dcfb3133c3b5e2e18197c749633974b348a082888f007e227c43d8c6"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "33ffd13dc4476f1006a2b10b00fbdc818178f902299d0384a98362c929268954"
  end

  depends_on "erlang@25" => [:build, :test]
  depends_on "erlang"

  def install
    erlang_build_dep = deps.find { |dep| dep.build? && dep.name.match?(/^erlang@\d+$/) }&.to_formula
    odie "Could not find build-time erlang!" if erlang_build_dep.blank?

    # To guarantee compatibility with various erlang versions, build with an older erlang.
    # We want to use `erlang@#{x-2}` where x is the major version of the `erlang` formula.
    build_erlang_version = erlang_build_dep.version.major.to_i
    wanted_erlang_version = Formula["erlang"].version.major.to_i - 2
    if wanted_erlang_version != build_erlang_version
      odie "This formula should be built with `erlang@#{wanted_erlang_version}`"
    end

    # Ensure we're building with versioned `erlang`
    ENV.remove "PATH", "#{Formula["erlang"].opt_bin}:"
    system "./bootstrap"
    bin.install "rebar3"

    bash_completion.install "apps/rebar/priv/shell-completion/bash/rebar3"
    zsh_completion.install "apps/rebar/priv/shell-completion/zsh/_rebar3"
    fish_completion.install "apps/rebar/priv/shell-completion/fish/rebar3.fish"
  end

  test do
    deps.each do |dep|
      next unless dep.name.match?(/^erlang(@\d+)?$/)

      erlang = dep.to_formula
      erlang_bin = erlang.opt_bin
      erlang_version = erlang.version.major
      with_env(PATH: "#{erlang_bin}:#{ENV["PATH"]}") do
        assert_match "OTP #{erlang_version}", shell_output("#{bin}/rebar3 --version")
      end
    end
  end
end
