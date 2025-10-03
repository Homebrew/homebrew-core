class Yor < Formula
  desc "Extensible auto-tagger for your IaC files"
  homepage "https://yor.io/"
  url "https://github.com/bridgecrewio/yor/archive/refs/tags/0.1.200.tar.gz"
  sha256 "157f2fc97aafa815dc5efaf1b398950181678953beff5e7736943b73b618b96a"
  license "Apache-2.0"
  head "https://github.com/bridgecrewio/yor.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_tahoe:   "5093c27de138a131d29e9b82498757aaea499bdaed28051c8267349ab14e9214"
    sha256 cellar: :any_skip_relocation, arm64_sequoia: "bec81b4e0759d619616eecc9f20be5c595c59a4a3d54d2931048317a6ce32a7b"
    sha256 cellar: :any_skip_relocation, arm64_sonoma:  "dc53606bf732f1838b233ea2a92f3550accf86204ebfe9e4020abcb77931cb2d"
    sha256 cellar: :any_skip_relocation, arm64_ventura: "5292c622765f09f2c292a85bf3a74738aca1f1d39a3ca0f368d18c62803ec2c3"
    sha256 cellar: :any_skip_relocation, sonoma:        "a2d75e2772ffaf1f6f57a6dedf7c535543e373d7dc640e2a9b2cb1c3671504a4"
    sha256 cellar: :any_skip_relocation, ventura:       "a8d04551bd36e0df696da02646ef12f9cf2baecfb15b83a88f191f6a82b8c77e"
    sha256 cellar: :any_skip_relocation, arm64_linux:   "ae580ba85dee0c2690c2055c86eea3834afe7dcd7fb10795c95218c32bff2874"
    sha256 cellar: :any_skip_relocation, x86_64_linux:  "f04dc74ea3f0833efc5b250eec99459aea5d626f7ce9d08845fb30878919fcdc"
  end

  depends_on "go" => :build

  def install
    inreplace "src/common/version.go", "Version = \"9.9.9\"", "Version = \"#{version}\""
    system "go", "build", *std_go_args(ldflags: "-s -w")
  end

  test do
    assert_match version.to_s, shell_output("#{bin}/yor --version")

    assert_match "yor_trace", shell_output("#{bin}/yor list-tags")
    assert_match "code2cloud", shell_output("#{bin}/yor list-tag-groups")
  end
end
