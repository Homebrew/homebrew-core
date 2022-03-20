class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.0.1.tar.gz"
  sha256 "a4cf636df8ba1f1b1ee78c2f838c124e720cbae5c42e211bc7ff3ddd6071f5b7"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "166c4f0060b06129b4f286aaa5598fa0b9fe08de10b66c9fa601fdc7381d444a"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "4aefd107ede935c6a958e63611f25f92947a47276048d6b767b82a44f3e28d51"
    sha256 cellar: :any_skip_relocation, monterey:       "8a60b69ec720cb92bea264dae5e2a7b50103e1c61a3941421a0ccb97d0b022b0"
    sha256 cellar: :any_skip_relocation, big_sur:        "cfae65e38538cc4094c9f0261392d94437107a7777ae63105ebfffac99357c5e"
    sha256 cellar: :any_skip_relocation, catalina:       "26a9f10c1b25336340e01badb210c4f18142c678827b7c0025e3c2b3d62c9cbb"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "163c1a4ae8589504f5be77918a3f1e80201c9eab03f0487910bfffc37f8a24e2"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    system "cabal", "v2-install", *std_cabal_v2_args
  end

  test do
    (testpath/"test.hs").write <<~EOS
      {-# LANGUAGE ViewPatterns, TemplateHaskell #-}
      {-# LANGUAGE GeneralizedNewtypeDeriving,
                  ViewPatterns,
          ScopedTypeVariables #-}

      module Bad where

      import Control.Applicative ((<$>))
      import System.Directory (doesFileExist)

      import qualified Data.Map as M
      import      Data.Map    ((!), keys, Map)
    EOS
    expected = <<~EOS
      {-# LANGUAGE GeneralizedNewtypeDeriving #-}
      {-# LANGUAGE ScopedTypeVariables        #-}
      {-# LANGUAGE TemplateHaskell            #-}

      module Bad where

      import           Control.Applicative ((<$>))
      import           System.Directory    (doesFileExist)

      import           Data.Map            (Map, keys, (!))
      import qualified Data.Map            as M
    EOS
    assert_equal expected, shell_output("#{bin}/stylish-haskell test.hs")
  end
end
