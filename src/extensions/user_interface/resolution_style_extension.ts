import { WebviewExtension } from '../webview_extension';

export class ResolutionStyleExtension implements WebviewExtension {
  public generateContent(): string {
    return `
      #resolutions {
        position: absolute;
        top: 1%;
        left: 28%;
        color: #fff;
        padding: 3px 5px;
        background: #000;
        border-radius: 5px;
        z-index: 1;
      }
    `;
  }
}
