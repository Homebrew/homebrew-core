class Rebar3 < Formula
  desc "Erlang build tool"
  homepage "https://rebar3.org"
  url "https://github.com/erlang/rebar3/archive/refs/tags/3.27.3.tar.gz"
  sha256 "2cf3a0d9a37ad9715fdb870b161ff61282048588ddb424362dacc22444c2d1f8"
  license "Apache-2.0"

  livecheck do
    url :stable
    regex(/^v?(\d+(?:\.\d+)+)$/i)
  end

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_golden_gate: "05dd411704c6e27246ffa7014c871879c3566afc85d9d26f164ece11892729c2"
    sha256 cellar: :any_skip_relocation, arm64_tahoe:       "521e4627aa969ddb3b2cdca2d3365dfc5bf399b7dbd1e3494d9f025602872123"
    sha256 cellar: :any_skip_relocation, arm64_sequoia:     "8e38d6115735e142b642d2ba0dad57decb498eb9c1c153ac37d60e43c722e4d8"
    sha256 cellar: :any_skip_relocation, arm64_linux:       "21899cd36d8de27da44e33a8e69ba9f2b7b07a6d85eebddac63c4cf7922bf4eb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:      "83c72bffb212cd8be582b9fc29ae6f487aab2dc0b5b7cb9ac18aba16ba6e25ed"
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
