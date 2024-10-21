/// <reference types="react-scripts" />

module.exports = {
  process() {
    return { code: "module.exports = {};" };
  },
  getCacheKey() {
    // The output is always the same.
    return "svgTransform";
  },
};

declare module "*.svg" {
  import * as React from "react";

  export const ReactComponent: React.FunctionComponent<
    React.SVGProps<SVGSVGElement>
  >;

  const src: string;
  export default src;
}
