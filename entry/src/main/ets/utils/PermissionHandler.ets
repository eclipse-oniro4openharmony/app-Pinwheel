import { bundleManager } from '@kit.AbilityKit';
import { abilityAccessCtrl, Permissions } from '@kit.AbilityKit'
import { UIContext } from '@kit.ArkUI';

class PermissionHandler {
  private atManager: abilityAccessCtrl.AtManager = abilityAccessCtrl.createAtManager();
  private uiContext?: UIContext;

  checkPermissions(permissions: Permissions[]) {
    const bundleInfo =
      bundleManager.getBundleInfoForSelfSync(bundleManager.BundleFlag.GET_BUNDLE_INFO_WITH_APPLICATION);
    const tokenId = bundleInfo.appInfo.accessTokenId;
    const grantStatus = permissions.map(item => this.atManager.checkAccessTokenSync(tokenId, item));
    return grantStatus.every(item => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
  }

  async requestPermissions(permissions: Permissions[]) {
    const requestRes = await this.atManager.requestPermissionsFromUser(this.uiContext?.getHostContext() as Context, permissions);
    const isAuth = requestRes.authResults.every((item: number) => item === abilityAccessCtrl.GrantStatus.PERMISSION_GRANTED);
    return isAuth === true ? Promise.resolve(true) : Promise.reject(false);
  }
}

export const permissionHandler = new PermissionHandler();