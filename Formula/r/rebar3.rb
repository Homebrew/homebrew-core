class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.28.0.tar.gz"
  sha256 "4a8bdd1fc845742833988db73012b232a3e9fd048011189ae9e0cecf70bdb7a2"
  license "Apache-2.0"
  compatibility_version 1

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "92f7de0659bba61ca985f9c004793c8a85fc4c4839cfa678004bfe7fd7363cd2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "0d74270a6f9bfd5f1248b7eddf5d35334a9b205dd1970437010b8131fa4581ed"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "ea808c2254b3b487093f8c3427ac11f25d566d69e79ece86334054d3a86b68f3"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "89acff2c45406fd8c62ff6be3b6959b26e5fd434d6698ba5184916b7cbe21b69"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "067fd6f364f78de86c2ad8e16c27f0cfca3542c482027c191d42db771663423d"
  end

  depends_on "erlang@27" => [:build, :test]
  depends_on "erlang" => :test

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
    ENV.remove "PATH", "#{formula_opt_bin("erlang")}:"
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
