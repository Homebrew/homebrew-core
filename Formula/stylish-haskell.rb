class StylishHaskell < Formula
  desc "Haskell code prettifier"
  homepage "https://github.com/haskell/stylish-haskell"
  url "https://github.com/haskell/stylish-haskell/archive/v0.14.3.0.tar.gz"
  sha256 "27f8b372e5ff18608f1db22598c99bb3d535083a65b02ebc40af5fc0b3b4ed38"
  license "BSD-3-Clause"
  head "https://github.com/haskell/stylish-haskell.git", branch: "main"

  bottle do
    sha256 cellar: :any_skip_relocation, arm64_monterey: "51d558bc19d94bf7ce019e4be28fe016e8ca51f80b7f8853b3287f5705f14760"
    sha256 cellar: :any_skip_relocation, arm64_big_sur:  "6171291422a4cf5d2281f6cf0d4f9cfc3aa6c3b68beb38b81bfdee37fc4a60da"
    sha256 cellar: :any_skip_relocation, ventura:        "66e5d594e32b86480288e83ae9589c754e9796a6148b8b4992c1bb405688c7ef"
    sha256 cellar: :any_skip_relocation, monterey:       "4b89870742215a1bf3e88b9c5bef2e999b5ec611c8134efbab034c240a6f2846"
    sha256 cellar: :any_skip_relocation, big_sur:        "6b6506f2723daf41c9ca4f072211b7021b238f16451a41b8345cfa7984dcf674"
    sha256 cellar: :any_skip_relocation, catalina:       "05bdaee2bff49b3e3853f66a0e9da5c68785e17ba97012e02f0e27a98744982d"
    sha256 cellar: :any_skip_relocation, x86_64_linux:   "a7f9a242e4cde7e144b70997f992e3e40c6f11c83644cd43282c227e06a61b7b"
  end

  depends_on "cabal-install" => :build
  depends_on "ghc" => :build

  def install
    system "cabal", "v2-update"
    # Work around build failure by enabling `ghc-lib` flag
    # lib/Language/Haskell/Stylish/GHC.hs:71:32: error:
    #     • Couldn't match expected type 'GHC.Settings'
    #                   with actual type 'ghc-lib-parser-9.2.4.20220729:GHC.Settings.Settings'
    # Issue ref: https://github.com/haskell/stylish-haskell/issues/405
    system "cabal", "v2-install", *std_cabal_v2_args, "--flags=+ghc-lib"
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
